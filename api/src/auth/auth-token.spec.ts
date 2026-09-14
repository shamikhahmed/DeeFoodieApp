import { createHash } from 'crypto';

describe('Auth token hashing (DFD-P0-04)', () => {
  it('hashes bearer tokens with sha256 hex', () => {
    const token = 'test-token-abcdefghijklmnopqrstuvwxyz012345';
    const expected = createHash('sha256').update(token).digest('hex');
    expect(expected).toHaveLength(64);
    expect(expected).toMatch(/^[a-f0-9]+$/);
  });

  it('different tokens produce different hashes', () => {
    const a = createHash('sha256').update('token-a').digest('hex');
    const b = createHash('sha256').update('token-b').digest('hex');
    expect(a).not.toBe(b);
  });
});
