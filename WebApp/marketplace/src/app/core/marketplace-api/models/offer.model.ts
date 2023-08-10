export class OfferModel {

  constructor(
    public user?: {
      username: string
    },
    public userId?: number,
    public categoryId?: number,
    public category?: {
      name: string
    },
    public description?: string,
    public location?: string,
    public pictureUrl?: string,
    public title?: string,
    public publishedOn?: string
  ) {

  }
}
