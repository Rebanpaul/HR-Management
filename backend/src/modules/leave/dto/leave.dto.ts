import { IsString, IsNotEmpty, IsDateString, IsOptional, IsEnum } from 'class-validator';

export class CreateLeaveDto {
  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsString()
  @IsNotEmpty()
  reason: string;

  @IsString()
  @IsOptional()
  leaveType?: string; // CASUAL, SICK, EARNED
}

export class UpdateLeaveStatusDto {
  @IsEnum(['APPROVED', 'REJECTED'])
  status: 'APPROVED' | 'REJECTED';
}
