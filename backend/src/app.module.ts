import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './common/prisma/prisma.module';
import { IdentityModule } from './modules/identity/identity.module';
import { HrModule } from './modules/hr/hr.module';
import { AttendanceModule } from './modules/attendance/attendance.module';
import { PayrollModule } from './modules/payroll/payroll.module';
import { TenantMiddleware } from './common/middleware/tenant.middleware';

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
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Tenant middleware applied to all routes except auth
    consumer
      .apply(TenantMiddleware)
      .exclude('api/auth/(.*)')
      .forRoutes('*');
  }
}
