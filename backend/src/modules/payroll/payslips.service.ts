import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import { CreatePayslipDto } from './dto/payslip.dto';

@Injectable()
export class PayslipsService {
  constructor(private prisma: PrismaService) {}

  async create(tenantId: string, dto: CreatePayslipDto) {
    return this.prisma.payslip.create({
      data: {
        ...dto,
        deductions: dto.deductions || 0,
        tenantId,
      },
      include: {
        employee: {
          select: { firstName: true, lastName: true, employeeCode: true },
        },
      },
    });
  }

  async findMyPayslips(userId: string, tenantId: string) {
    const employee = await this.prisma.employee.findFirst({
      where: { userId, tenantId },
    });

    if (!employee) return [];

    return this.prisma.payslip.findMany({
      where: { employeeId: employee.id, tenantId },
      orderBy: [{ year: 'desc' }, { month: 'desc' }],
    });
  }

  async findAllByTenant(tenantId: string, year?: number) {
    const where: any = { tenantId };
    if (year) where.year = year;

    return this.prisma.payslip.findMany({
      where,
      include: {
        employee: {
          select: { firstName: true, lastName: true, employeeCode: true },
        },
      },
      orderBy: [{ year: 'desc' }, { month: 'desc' }],
    });
  }

  async findById(id: string, tenantId: string) {
    const payslip = await this.prisma.payslip.findFirst({
      where: { id, tenantId },
      include: {
        employee: {
          select: { firstName: true, lastName: true, employeeCode: true },
        },
      },
    });

    if (!payslip) throw new NotFoundException('Payslip not found');
    return payslip;
  }
}
