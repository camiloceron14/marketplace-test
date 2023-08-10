export class PageModel<T> {

    constructor(
      public pageNumber: number,
      public pageSize: number,
      public firstPage: string,
      public lastPage: string,
      public totalPages: number,
      public totalRecords: number,
      public nextPage: string,
      public previousPage: string,
      public data: any
    ) {
  
    }
  
  }