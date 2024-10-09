import { Injectable } from '@nestjs/common';

const evalPdfLib = async () => {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  return (await eval(`import('pdf-to-img')`)) as Promise<
    typeof import('pdf-to-img')
  >;
};

@Injectable()
export class AppService {
  async processUpload(file: Express.Multer.File) {
    console.log(`Processing file ${file.originalname}`);
    const { pdf } = await evalPdfLib();
    const document = await pdf(file.buffer, { scale: 3 });
    const images = [];
    for await (const image of document) {
      images.push(image);
    }

    return images;
  }
}
