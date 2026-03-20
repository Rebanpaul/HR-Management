import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import { CreateLeaveDto, UpdateLeaveStatusDto } from './dto/leave.dto';

@Injectable()
export class LeaveService {
  constructor(private prisma: PrismaService) {}

  /**
   * Employee creates a leave request
   */
  async create(userId: string, tenantId: string, dto: CreateLeaveDto) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) {
      throw new NotFoundException('Employee profile not found');
    }

    // Validate dates
    const startDate = new Date(dto.startDate);
    const endDate = new Date(dto.endDate);
    if (endDate < startDate) {
      throw new BadRequestException('End date must be after start date');
    }

    return this.prisma.leaveRequest.create({
      data: {
        startDate,
        endDate,
        reason: dto.reason,
        leaveType: dto.leaveType || 'CASUAL',
        employeeId: employee.id,
        tenantId,
      },
      include: {
        employee: {
          select: { firstName: true, lastName: true, employeeCode: true },
        },
      },
    });
  }

  /**
   * Employee views their own leave requests
   */
  async findMyLeaves(userId: string, tenantId: string) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) return [];

    return this.prisma.leaveRequest.findMany({
      where: { employeeId: employee.id, tenantId },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Manager / HR views all leave requests for the tenant
   */
  async findTeamLeaves(tenantId: string, status?: string) {
    const where: any = { tenantId };
    if (status) where.status = status;

    return this.prisma.leaveRequest.findMany({
      where,
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
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Manager / HR approves or rejects a leave request
   */
  async updateStatus(
    leaveId: string,
    tenantId: string,
    dto: UpdateLeaveStatusDto,
  ) {
    const leave = await this.prisma.leaveRequest.findFirst({
      where: { id: leaveId, tenantId },
    });

    if (!leave) {
      throw new NotFoundException('Leave request not found');
    }

    if (leave.status !== 'PENDING') {
      throw new BadRequestException(
        `Leave request is already ${leave.status.toLowerCase()}`,
      );
    }

    return this.prisma.leaveRequest.update({
      where: { id: leaveId },
      data: { status: dto.status },
      include: {
        employee: {
          select: { firstName: true, lastName: true, employeeCode: true },
        },
      },
    });
  }

  /**
   * Get leave balance summary for an employee
   */
  async getBalance(userId: string, tenantId: string) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) return { casual: 0, sick: 0, earned: 0 };

    const currentYear = new Date().getFullYear();

    const approved = await this.prisma.leaveRequest.findMany({
      where: {
        employeeId: employee.id,
        tenantId,
        status: 'APPROVED',
        startDate: {
          gte: new Date(`${currentYear}-01-01`),
        },
      },
    });

    // Calculate used leaves by type
    let casualUsed = 0;
    let sickUsed = 0;
    let earnedUsed = 0;

    for (const leave of approved) {
      const days =
        Math.ceil(
          (leave.endDate.getTime() - leave.startDate.getTime()) /
            (1000 * 60 * 60 * 24),
        ) + 1;

      switch (leave.leaveType) {
        case 'CASUAL':
          casualUsed += days;
          break;
        case 'SICK':
          sickUsed += days;
          break;
        case 'EARNED':
          earnedUsed += days;
          break;
      }
    }

    // Default annual allowances (can be made configurable per tenant later)
    return {
      casual: { total: 12, used: casualUsed, remaining: 12 - casualUsed },
      sick: { total: 8, used: sickUsed, remaining: 8 - sickUsed },
      earned: { total: 15, used: earnedUsed, remaining: 15 - earnedUsed },
    };
  }
}
