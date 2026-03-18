import {
  Controller,
  Get,
  Put,
  Param,
  Body,
  UseGuards,
  Req,
} from '@nestjs/common';
import { EmployeesService } from './employees.service';
import { UpdateEmployeeDto } from './dto/employee.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@Controller('employees')
@UseGuards(JwtAuthGuard, RolesGuard)
export class EmployeesController {
  constructor(private employeesService: EmployeesService) {}

  @Get()
  @Roles('HR_ADMIN', 'SUPER_ADMIN')
  async findAll(@Req() req) {
    return this.employeesService.findAll(req.user.tenantId);
  }

  @Get('me')
  async findMe(@Req() req) {
    return this.employeesService.findByUserId(req.user.sub, req.user.tenantId);
  }

  @Get(':id')
  @Roles('HR_ADMIN', 'SUPER_ADMIN', 'MANAGER')
  async findById(@Param('id') id: string, @Req() req) {
    return this.employeesService.findById(id, req.user.tenantId);
  }

  @Put(':id')
  @Roles('HR_ADMIN', 'SUPER_ADMIN')
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateEmployeeDto,
    @Req() req,
  ) {
    return this.employeesService.update(id, req.user.tenantId, dto);
  }
}
