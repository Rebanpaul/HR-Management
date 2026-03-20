import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...\n');

  // ── 1. Create Tenant ──────────────────────────────────
  const tenant = await prisma.tenant.upsert({
    where: { domain: 'demo.staffsource.com' },
    update: {},
    create: {
      name: 'StaffSource Demo',
      domain: 'demo.staffsource.com',
    },
  });
  console.log(`✅ Tenant: ${tenant.name} (${tenant.id})`);

  // ── 2. Create Department ──────────────────────────────
  const engineering = await prisma.department.upsert({
    where: { id: 'seed-dept-engineering' },
    update: {},
    create: {
      id: 'seed-dept-engineering',
      name: 'Engineering',
      tenantId: tenant.id,
    },
  });

  const hr = await prisma.department.upsert({
    where: { id: 'seed-dept-hr' },
    update: {},
    create: {
      id: 'seed-dept-hr',
      name: 'Human Resources',
      tenantId: tenant.id,
    },
  });
  console.log(`✅ Departments: Engineering, Human Resources`);

  // ── 3. Create Super Admin ─────────────────────────────
  const adminPassword = await bcrypt.hash('admin123', 12);
  const adminUser = await prisma.user.upsert({
    where: { email_tenantId: { email: 'admin@staffsource.com', tenantId: tenant.id } },
    update: {},
    create: {
      email: 'admin@staffsource.com',
      password: adminPassword,
      role: 'SUPER_ADMIN',
      tenantId: tenant.id,
    },
  });

  await prisma.employee.upsert({
    where: { userId: adminUser.id },
    update: {},
    create: {
      employeeCode: 'EMP-0001',
      firstName: 'System',
      lastName: 'Admin',
      designation: 'Super Administrator',
      userId: adminUser.id,
      departmentId: hr.id,
      tenantId: tenant.id,
    },
  });
  console.log(`✅ Super Admin: admin@staffsource.com / admin123`);

  // ── 4. Create HR Admin ────────────────────────────────
  const hrPassword = await bcrypt.hash('hr1234', 12);
  const hrUser = await prisma.user.upsert({
    where: { email_tenantId: { email: 'hr@staffsource.com', tenantId: tenant.id } },
    update: {},
    create: {
      email: 'hr@staffsource.com',
      password: hrPassword,
      role: 'HR_ADMIN',
      tenantId: tenant.id,
    },
  });

  await prisma.employee.upsert({
    where: { userId: hrUser.id },
    update: {},
    create: {
      employeeCode: 'EMP-0002',
      firstName: 'Priya',
      lastName: 'Sharma',
      designation: 'HR Manager',
      userId: hrUser.id,
      departmentId: hr.id,
      tenantId: tenant.id,
    },
  });
  console.log(`✅ HR Admin:    hr@staffsource.com / hr1234`);

  // ── 5. Create Manager ─────────────────────────────────
  const mgrPassword = await bcrypt.hash('manager123', 12);
  const mgrUser = await prisma.user.upsert({
    where: { email_tenantId: { email: 'manager@staffsource.com', tenantId: tenant.id } },
    update: {},
    create: {
      email: 'manager@staffsource.com',
      password: mgrPassword,
      role: 'MANAGER',
      tenantId: tenant.id,
    },
  });

  await prisma.employee.upsert({
    where: { userId: mgrUser.id },
    update: {},
    create: {
      employeeCode: 'EMP-0003',
      firstName: 'Rahul',
      lastName: 'Kumar',
      designation: 'Engineering Lead',
      userId: mgrUser.id,
      departmentId: engineering.id,
      tenantId: tenant.id,
    },
  });
  console.log(`✅ Manager:     manager@staffsource.com / manager123`);

  // ── 6. Create 2 Employees ─────────────────────────────
  const empPassword = await bcrypt.hash('employee123', 12);

  const emp1User = await prisma.user.upsert({
    where: { email_tenantId: { email: 'syed@staffsource.com', tenantId: tenant.id } },
    update: {},
    create: {
      email: 'syed@staffsource.com',
      password: empPassword,
      role: 'EMPLOYEE',
      tenantId: tenant.id,
    },
  });

  await prisma.employee.upsert({
    where: { userId: emp1User.id },
    update: {},
    create: {
      employeeCode: 'EMP-0004',
      firstName: 'Syed',
      lastName: 'Shah',
      designation: 'Software Developer',
      phone: '+91 9876543210',
      userId: emp1User.id,
      departmentId: engineering.id,
      tenantId: tenant.id,
    },
  });
  console.log(`✅ Employee:    syed@staffsource.com / employee123`);

  const emp2User = await prisma.user.upsert({
    where: { email_tenantId: { email: 'aisha@staffsource.com', tenantId: tenant.id } },
    update: {},
    create: {
      email: 'aisha@staffsource.com',
      password: empPassword,
      role: 'EMPLOYEE',
      tenantId: tenant.id,
    },
  });

  await prisma.employee.upsert({
    where: { userId: emp2User.id },
    update: {},
    create: {
      employeeCode: 'EMP-0005',
      firstName: 'Aisha',
      lastName: 'Khan',
      designation: 'UI/UX Designer',
      phone: '+91 9876543211',
      userId: emp2User.id,
      departmentId: engineering.id,
      tenantId: tenant.id,
    },
  });
  console.log(`✅ Employee:    aisha@staffsource.com / employee123`);

  console.log('\n🎉 Seed completed! Use the Tenant ID below for login:');
  console.log(`   Tenant ID: ${tenant.id}`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
