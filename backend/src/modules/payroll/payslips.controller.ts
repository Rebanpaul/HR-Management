import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import { PayslipsService } from './payslips.service';
import { CreatePayslipDto } from './dto/payslip.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@Controller('payslips')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PayslipsController {
  constructor(private payslipsService: PayslipsService) {}

  @Post()
  @Roles('HR_ADMIN', 'SUPER_ADMIN')
  async create(@Body() dto: CreatePayslipDto, @Req() req) {
    return this.payslipsService.create(req.user.tenantId, dto);
  }

  @Get('me')
  async findMyPayslips(@Req() req) {
    return this.payslipsService.findMyPayslips(
      req.user.sub,
      req.user.tenantId,
    );
  }

  @Get()
  @Roles('HR_ADMIN', 'SUPER_ADMIN')
  async findAll(@Req() req, @Query('year') year?: string) {
    return this.payslipsService.findAllByTenant(
      req.user.tenantId,
      year ? parseInt(year) : undefined,
    );
  }

  @Get(':id')
  async findById(@Param('id') id: string, @Req() req) {
    return this.payslipsService.findById(id, req.user.tenantId);
  }
}
