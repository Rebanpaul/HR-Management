import {
  Controller,
  Post,
  Get,
  Body,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { PunchInDto, PunchOutDto } from './dto/attendance.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@Controller('attendance')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AttendanceController {
  constructor(private attendanceService: AttendanceService) {}

  @Post('punch-in')
  async punchIn(@Req() req, @Body() dto: PunchInDto) {
    return this.attendanceService.punchIn(
      req.user.sub,
      req.user.tenantId,
      dto,
    );
  }

  @Post('punch-out')
  async punchOut(@Req() req, @Body() dto: PunchOutDto) {
    return this.attendanceService.punchOut(
      req.user.sub,
      req.user.tenantId,
      dto,
    );
  }

  @Get('today')
  async getToday(@Req() req) {
    return this.attendanceService.getToday(req.user.sub, req.user.tenantId);
  }

  @Get('history')
  async getHistory(
    @Req() req,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.attendanceService.getHistory(
      req.user.sub,
      req.user.tenantId,
      page ? parseInt(page) : 1,
      limit ? parseInt(limit) : 20,
    );
  }

  @Get('team')
  @Roles('MANAGER', 'HR_ADMIN', 'SUPER_ADMIN')
  async getTeamAttendance(@Req() req, @Query('date') date?: string) {
    return this.attendanceService.getTeamAttendance(req.user.tenantId, date);
  }
}
