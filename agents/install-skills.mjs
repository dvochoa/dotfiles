#!/usr/bin/env node

import { readFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const agentsDir = dirname(fileURLToPath(import.meta.url));
const lockPath = join(agentsDir, '.skill-lock.json');
const lock = JSON.parse(readFileSync(lockPath, 'utf8'));
const agents = lock.lastSelectedAgents;

if (!Array.isArray(agents) || agents.length === 0) {
  throw new Error(`${lockPath} has no selected agents`);
}

for (const [name, skill] of Object.entries(lock.skills)) {
  if (!skill.sourceUrl) {
    throw new Error(`${name} has no sourceUrl in ${lockPath}`);
  }

  const result = spawnSync(
    'npx',
    [
      '--yes',
      'skills',
      'add',
      skill.sourceUrl,
      '--skill',
      name,
      '--agent',
      ...agents,
      '--global',
      '--yes',
    ],
    { stdio: 'inherit' }
  );

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
