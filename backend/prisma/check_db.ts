import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('--- Database Diagnostic ---');
  
  const tenants = await prisma.tenant.findMany();
  console.log('Tenants Found:', tenants.length);
  tenants.forEach(t => console.log(`- ${t.name} (${t.id})`));

  const users = await prisma.user.findMany({
    include: { tenant: true }
  });
  console.log('\nUsers Found:', users.length);
  users.forEach(u => {
    console.log(`- ${u.email} | Tenant: ${u.tenant.name} (${u.tenantId}) | Role: ${u.role}`);
  });

  console.log('--- End Diagnostic ---');
}

main()
  .catch(e => console.error(e))
  .finally(async () => {
    await prisma.$disconnect();
  });
