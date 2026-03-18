import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import { UpdateEmployeeDto } from './dto/employee.dto';

@Injectable()
export class EmployeesService {
  constructor(private prisma: PrismaService) {}

  async findAll(tenantId: string) {
    return this.prisma.employee.findMany({
      where: { tenantId },
      include: {
        user: { select: { email: true, role: true } },
        department: { select: { name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findById(id: string, tenantId: string) {
    const employee = await this.prisma.employee.findFirst({
      where: { id, tenantId },
      include: {
        user: { select: { email: true, role: true } },
        department: true,
      },
    });

    if (!employee) {
      throw new NotFoundException('Employee not found');
    }

    return employee;
  }

  async findByUserId(userId: string, tenantId: string) {
    return this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });
  }

  async update(id: string, tenantId: string, dto: UpdateEmployeeDto) {
    const employee = await this.findById(id, tenantId);

    return this.prisma.employee.update({
      where: { id: employee.id },
      data: dto,
      include: {
        user: { select: { email: true, role: true } },
        department: { select: { name: true } },
      },
    });
  }
}
