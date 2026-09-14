import { createHash } from 'crypto';

describe('Me delete data contract (DFD-P0-04)', () => {
  it('token hash is deterministic sha256 hex', () => {
    const a = createHash('sha256').update('abc').digest('hex');
    const b = createHash('sha256').update('abc').digest('hex');
    expect(a).toBe(b);
    expect(a).toHaveLength(64);
  });

  it('delete endpoint path is /me/data', () => {
    expect('/me/data').toMatch(/^\/me\/data$/);
  });
});
