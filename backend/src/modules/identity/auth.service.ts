import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../../common/prisma/prisma.service';
import { RegisterDto, LoginDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(dto: RegisterDto) {
    // Check if user already exists in this tenant
    const existingUser = await this.prisma.user.findUnique({
      where: {
        email_tenantId: {
          email: dto.email,
          tenantId: dto.tenantId,
        },
      },
    });

    if (existingUser) {
      throw new ConflictException('User with this email already exists in this tenant');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(dto.password, 12);

    // Create user + employee in a transaction
    const result = await this.prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          email: dto.email,
          password: hashedPassword,
          role: dto.role || 'EMPLOYEE',
          tenantId: dto.tenantId,
        },
      });

      // Auto-create an employee profile
      const employeeCount = await tx.employee.count({
        where: { tenantId: dto.tenantId },
      });

      const employee = await tx.employee.create({
        data: {
          employeeCode: `EMP-${String(employeeCount + 1).padStart(4, '0')}`,
          firstName: dto.firstName,
          lastName: dto.lastName,
          userId: user.id,
          tenantId: dto.tenantId,
        },
      });

      return { user, employee };
    });

    // Generate tokens
    const tokens = await this.generateTokens(
      result.user.id,
      result.user.email,
      result.user.role,
      result.user.tenantId,
    );

    // Save refresh token
    await this.prisma.user.update({
      where: { id: result.user.id },
      data: { refreshToken: await bcrypt.hash(tokens.refreshToken, 10) },
    });

    return {
      user: {
        id: result.user.id,
        email: result.user.email,
        role: result.user.role,
        tenantId: result.user.tenantId,
        employee: {
          id: result.employee.id,
          employeeCode: result.employee.employeeCode,
          firstName: result.employee.firstName,
          lastName: result.employee.lastName,
        },
      },
      ...tokens,
    };
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: {
        email_tenantId: {
          email: dto.email,
          tenantId: dto.tenantId,
        },
      },
      include: {
        employee: true,
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const passwordMatch = await bcrypt.compare(dto.password, user.password);
    if (!passwordMatch) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const tokens = await this.generateTokens(
      user.id,
      user.email,
      user.role,
      user.tenantId,
    );

    // Save refresh token hash
    await this.prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: await bcrypt.hash(tokens.refreshToken, 10) },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        tenantId: user.tenantId,
        employee: user.employee
          ? {
              id: user.employee.id,
              employeeCode: user.employee.employeeCode,
              firstName: user.employee.firstName,
              lastName: user.employee.lastName,
            }
          : null,
      },
      ...tokens,
    };
  }

  async refreshTokens(userId: string, refreshToken: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });

    if (!user || !user.refreshToken) {
      throw new UnauthorizedException('Access denied');
    }

    const tokenMatch = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!tokenMatch) {
      throw new UnauthorizedException('Access denied');
    }

    const tokens = await this.generateTokens(
      user.id,
      user.email,
      user.role,
      user.tenantId,
    );

    await this.prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: await bcrypt.hash(tokens.refreshToken, 10) },
    });

    return tokens;
  }

  async logout(userId: string) {
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
  }

  private async generateTokens(
    userId: string,
    email: string,
    role: string,
    tenantId: string,
  ) {
    const payload = { sub: userId, email, role, tenantId };

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload),
      this.jwtService.signAsync(payload, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
        expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRATION', '7d'),
      }),
    ]);

    return { accessToken, refreshToken };
  }
}
