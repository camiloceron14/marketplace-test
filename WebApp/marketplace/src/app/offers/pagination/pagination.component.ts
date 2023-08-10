import { Component, Input, OnInit, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-pagination',
  templateUrl: './pagination.component.html',
  styleUrls: ['./pagination.component.scss']
})
export class PaginationComponent implements OnInit {

  @Input() totalPages;
  @Input() hasNext = false;
  @Input() hasPrevious = false;

  @Output() changePageEvent: EventEmitter<number> = new EventEmitter();

  pageActive = 1;

  constructor() { }

  ngOnInit(): void {
  }

  onChangePage(pageActive: number):void{
    this.pageActive = pageActive;
    this.changePageEvent.emit(this.pageActive);
  }

}
