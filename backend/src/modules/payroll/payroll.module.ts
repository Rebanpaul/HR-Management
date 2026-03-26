import { Module } from '@nestjs/common';
import { PayslipsController } from './payslips.controller';
import { PayslipsService } from './payslips.service';

import { IdentityModule } from '../identity/identity.module';

@Module({
  imports: [IdentityModule],
  controllers: [PayslipsController],
  providers: [PayslipsService],
  exports: [PayslipsService],
})
export class PayrollModule {}
