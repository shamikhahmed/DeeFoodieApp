import { Injectable, Logger } from '@nestjs/common';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { mkdir, writeFile } from 'fs/promises';
import { join } from 'path';
import { randomUUID } from 'crypto';

type StorageDriver = 'local' | 's3';

@Injectable()
export class StorageService {
  private readonly logger = new Logger(StorageService.name);
  private readonly driver: StorageDriver;
  private readonly uploadDir: string;
  private readonly s3?: S3Client;
  private readonly s3Bucket?: string;
  private readonly s3PublicBase?: string;

  constructor() {
    this.driver = process.env.STORAGE_DRIVER === 's3' ? 's3' : 'local';
    this.uploadDir = process.env.UPLOAD_DIR ?? join(process.cwd(), 'uploads');

    if (this.driver === 's3') {
      const bucket = process.env.S3_BUCKET;
      const region = process.env.S3_REGION ?? 'auto';
      if (!bucket) {
        throw new Error('S3_BUCKET is required when STORAGE_DRIVER=s3');
      }
      this.s3Bucket = bucket;
      const endpoint = process.env.S3_ENDPOINT;
      this.s3 = new S3Client({
        region,
        endpoint: endpoint || undefined,
        forcePathStyle: Boolean(endpoint),
        credentials:
          process.env.S3_ACCESS_KEY_ID && process.env.S3_SECRET_ACCESS_KEY
            ? {
                accessKeyId: process.env.S3_ACCESS_KEY_ID,
                secretAccessKey: process.env.S3_SECRET_ACCESS_KEY,
              }
            : undefined,
      });
      this.s3PublicBase =
        process.env.S3_PUBLIC_BASE_URL?.replace(/\/$/, '') ??
        (endpoint ? `${endpoint.replace(/\/$/, '')}/${bucket}` : `https://${bucket}.s3.${region}.amazonaws.com`);
      this.logger.log(`S3 storage enabled bucket=${bucket}`);
    } else {
      this.logger.log(`Local storage enabled dir=${this.uploadDir}`);
    }
  }

  async saveBuffer(buffer: Buffer, ext: string, contentType?: string): Promise<string> {
    if (this.driver === 's3') return this.saveS3(buffer, ext, contentType);
    return this.saveLocal(buffer, ext);
  }

  private async saveLocal(buffer: Buffer, ext: string): Promise<string> {
    await mkdir(this.uploadDir, { recursive: true });
    const filename = `${randomUUID()}${ext}`;
    await writeFile(join(this.uploadDir, filename), buffer);
    return `/uploads/${filename}`;
  }

  private async saveS3(buffer: Buffer, ext: string, contentType?: string): Promise<string> {
    if (!this.s3 || !this.s3Bucket || !this.s3PublicBase) {
      throw new Error('S3 client not configured');
    }
    const key = `photos/${randomUUID()}${ext}`;
    await this.s3.send(
      new PutObjectCommand({
        Bucket: this.s3Bucket,
        Key: key,
        Body: buffer,
        ContentType: contentType ?? 'image/jpeg',
      }),
    );
    return `${this.s3PublicBase}/${key}`;
  }
}
