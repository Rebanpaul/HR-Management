import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

/**
 * TenantMiddleware extracts the tenant_id from the JWT token
 * and attaches it to the request object for downstream use.
 */
@Injectable()
export class TenantMiddleware implements NestMiddleware {
  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async use(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next();
    }

    try {
      const token = authHeader.split(' ')[1];
      const decoded = await this.jwtService.verifyAsync(token, {
        secret: this.configService.getOrThrow<string>('JWT_SECRET'),
      });

      (req as any).tenantId = decoded.tenantId;
      (req as any).userId = decoded.sub;
      (req as any).userRole = decoded.role;
    } catch {
      // Token invalid — let the auth guard handle it downstream
    }

    next();
  }
}
