import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findById(userId: string) {
    return this.prisma.user.findUnique({
      where: { id: userId },
      include: { employee: true },
    });
  }

  async findByEmail(email: string, tenantId: string) {
    return this.prisma.user.findUnique({
      where: {
        email_tenantId: { email, tenantId },
      },
      include: { employee: true },
    });
  }

  async findAllByTenant(tenantId: string) {
    return this.prisma.user.findMany({
      where: { tenantId },
      include: { employee: true },
      orderBy: { createdAt: 'desc' },
    });
  }
}
