import { Injectable, NestMiddleware, UnauthorizedException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import * as jwt from 'jsonwebtoken';
import { ConfigService } from '@nestjs/config';

/**
 * TenantMiddleware extracts the tenant_id from the JWT token
 * and attaches it to the request object for downstream use.
 */
@Injectable()
export class TenantMiddleware implements NestMiddleware {
  constructor(private configService: ConfigService) {}

  use(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      // Let the auth guard handle unauthorized requests
      return next();
    }

    try {
      const token = authHeader.split(' ')[1];
      const secret = this.configService.getOrThrow<string>('JWT_SECRET');
      const decoded = jwt.verify(token, secret) as any;

      // Attach tenant context to the request
      (req as any).tenantId = decoded.tenantId;
      (req as any).userId = decoded.sub;
      (req as any).userRole = decoded.role;
    } catch (error) {
      // Token is invalid — let the auth guard handle it
    }

    next();
  }
}
