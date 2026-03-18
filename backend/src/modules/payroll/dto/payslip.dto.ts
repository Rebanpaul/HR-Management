import { IsNumber, IsOptional, IsString } from 'class-validator';

export class CreatePayslipDto {
  @IsNumber()
  month: number;

  @IsNumber()
  year: number;

  @IsNumber()
  basicSalary: number;

  @IsNumber()
  @IsOptional()
  deductions?: number;

  @IsNumber()
  netSalary: number;

  @IsString()
  @IsOptional()
  pdfUrl?: string;

  @IsString()
  employeeId: string;
}
