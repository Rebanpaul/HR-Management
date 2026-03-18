import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import { PunchInDto, PunchOutDto } from './dto/attendance.dto';

@Injectable()
export class AttendanceService {
  constructor(private prisma: PrismaService) {}

  async punchIn(userId: string, tenantId: string, dto: PunchInDto) {
    // Find the employee for this user
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) {
      throw new NotFoundException('Employee profile not found');
    }

    // Check if already punched in today (no punch-out yet)
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const existingPunch = await this.prisma.attendance.findFirst({
      where: {
        employeeId: employee.id,
        tenantId,
        punchIn: { gte: today, lt: tomorrow },
        punchOut: null,
      },
    });

    if (existingPunch) {
      throw new BadRequestException(
        'You have already punched in today. Please punch out first.',
      );
    }

    return this.prisma.attendance.create({
      data: {
        punchIn: new Date(),
        punchInLat: dto.latitude,
        punchInLng: dto.longitude,
        notes: dto.notes,
        employeeId: employee.id,
        tenantId,
      },
    });
  }

  async punchOut(userId: string, tenantId: string, dto: PunchOutDto) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) {
      throw new NotFoundException('Employee profile not found');
    }

    // Find today's open punch-in record
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const openRecord = await this.prisma.attendance.findFirst({
      where: {
        employeeId: employee.id,
        tenantId,
        punchIn: { gte: today, lt: tomorrow },
        punchOut: null,
      },
    });

    if (!openRecord) {
      throw new BadRequestException(
        'No open punch-in record found for today. Please punch in first.',
      );
    }

    return this.prisma.attendance.update({
      where: { id: openRecord.id },
      data: {
        punchOut: new Date(),
        punchOutLat: dto.latitude,
        punchOutLng: dto.longitude,
      },
    });
  }

  async getToday(userId: string, tenantId: string) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) return null;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    return this.prisma.attendance.findFirst({
      where: {
        employeeId: employee.id,
        tenantId,
        punchIn: { gte: today, lt: tomorrow },
      },
    });
  }

  async getHistory(userId: string, tenantId: string, page = 1, limit = 20) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) return { data: [], total: 0 };

    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      this.prisma.attendance.findMany({
        where: { employeeId: employee.id, tenantId },
        orderBy: { punchIn: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.attendance.count({
        where: { employeeId: employee.id, tenantId },
      }),
    ]);

    return { data, total, page, limit };
  }

  async getTeamAttendance(tenantId: string, date?: string) {
    const targetDate = date ? new Date(date) : new Date();
    targetDate.setHours(0, 0, 0, 0);
    const nextDay = new Date(targetDate);
    nextDay.setDate(nextDay.getDate() + 1);

    return this.prisma.attendance.findMany({
      where: {
        tenantId,
        punchIn: { gte: targetDate, lt: nextDay },
      },
      include: {
        employee: {
          select: {
            firstName: true,
            lastName: true,
            employeeCode: true,
            department: { select: { name: true } },
          },
        },
      },
      orderBy: { punchIn: 'asc' },
    });
  }
}
