import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import { LeaveService } from './leave.service';
import { CreateLeaveDto, UpdateLeaveStatusDto } from './dto/leave.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@Controller('leave-requests')
@UseGuards(JwtAuthGuard, RolesGuard)
export class LeaveController {
  constructor(private leaveService: LeaveService) {}

  /**
   * Employee creates a leave request
   */
  @Post()
  async create(@Body() dto: CreateLeaveDto, @Req() req) {
    return this.leaveService.create(req.user.sub, req.user.tenantId, dto);
  }

  /**
   * Employee views their own leave requests
   */
  @Get('me')
  async findMyLeaves(@Req() req) {
    return this.leaveService.findMyLeaves(req.user.sub, req.user.tenantId);
  }

  /**
   * Employee views their leave balance
   */
  @Get('balance')
  async getBalance(@Req() req) {
    return this.leaveService.getBalance(req.user.sub, req.user.tenantId);
  }

  /**
   * Manager / HR views all leave requests for the tenant
   */
  @Get('team')
  @Roles('MANAGER', 'HR_ADMIN', 'SUPER_ADMIN')
  async findTeamLeaves(@Req() req, @Query('status') status?: string) {
    return this.leaveService.findTeamLeaves(req.user.tenantId, status);
  }

  /**
   * Manager / HR approves a leave request
   */
  @Patch(':id/approve')
  @Roles('MANAGER', 'HR_ADMIN', 'SUPER_ADMIN')
  async approve(@Param('id') id: string, @Req() req) {
    return this.leaveService.updateStatus(id, req.user.tenantId, {
      status: 'APPROVED',
    });
  }

  /**
   * Manager / HR rejects a leave request
   */
  @Patch(':id/reject')
  @Roles('MANAGER', 'HR_ADMIN', 'SUPER_ADMIN')
  async reject(@Param('id') id: string, @Req() req) {
    return this.leaveService.updateStatus(id, req.user.tenantId, {
      status: 'REJECTED',
    });
  }
}
