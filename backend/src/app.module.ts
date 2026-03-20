import { Module, NestModule, MiddlewareConsumer, Controller, Get } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/prisma/prisma.module';
import { PrismaService } from './common/prisma/prisma.service';
import { IdentityModule } from './modules/identity/identity.module';
import { HrModule } from './modules/hr/hr.module';
import { AttendanceModule } from './modules/attendance/attendance.module';
import { PayrollModule } from './modules/payroll/payroll.module';
import { LeaveModule } from './modules/leave/leave.module';
import { TenantMiddleware } from './common/middleware/tenant.middleware';

@Controller('health')
class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  check() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }

  @Get('db')
  async dbCheck() {
    // A lightweight query to verify DB connectivity.
    const tenantCount = await this.prisma.tenant.count();
    return {
      status: 'ok',
      db: 'ok',
      tenantCount,
      timestamp: new Date().toISOString(),
    };
  }
}

@Module({
  imports: [
    // Global config from .env
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Shared Prisma service
    PrismaModule,

    // Domain modules
    IdentityModule,
    HrModule,
    AttendanceModule,
    PayrollModule,
    LeaveModule,
  ],
  controllers: [HealthController],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Tenant middleware applied to all routes except auth and health
    consumer
      .apply(TenantMiddleware)
      .exclude('api/auth/(.*)', 'api/health', 'api/health/(.*)')
      .forRoutes('*');
  }
}

