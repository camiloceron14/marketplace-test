import {
  Component,
  EventEmitter,
  forwardRef,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

export interface PaginationValue {
  page: number;
  pageSize: number;
}

@Component({
  selector: 'app-paginator',
  templateUrl: './paginator.component.html',
  styleUrls: ['./paginator.component.scss'],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => PaginatorComponent),
      multi: true,
    },
  ],
})
export class PaginatorComponent
  implements OnInit, OnChanges, ControlValueAccessor
{
  @Input() value: PaginationValue = { page: 1, pageSize: 10 };
  @Input() total = 10;
  @Input() visibleRangeLength = 5;

  @Output() changePageEvent: EventEmitter<number> = new EventEmitter();

  goToPage: number = 0;

  onChangePage():void {
    this.changePageEvent.emit(this.value.page);
  }

  onChange(value: any) {
    this.onChangePage();
  }

  onTouched() {}

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouched = fn;
  }

  writeValue(value: PaginationValue): void {
    if (!value) return;

    this.value = value;
    this.updateTotalPages();
    this.updateVisiblePages();
  }

  public totalPages: number;
  public visiblePages: number[];

  ngOnInit(): void {
    this.updateVisiblePages();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.total || changes.value) this.updateTotalPages();
  }

  public goPage() {
    this.value.page = this.goToPage;
    this.updateVisiblePages();
    this.onChange(this.value);
  }

  public selectPage(page: number): void {
    this.value = { ...this.value, page };
    this.updateVisiblePages();
    this.onChange(this.value);
  }

  public selectPageSize(pageSize: string): void {
    this.value = { page: 1, pageSize: +pageSize };
    this.updateTotalPages();
    this.updateVisiblePages();
    this.onChange(this.value);
  }

  private updateVisiblePages(): void {
    const length = Math.min(this.totalPages, this.visibleRangeLength);

    const startIndex = Math.max(
      Math.min(
        this.value.page - Math.ceil(length / 2),
        this.totalPages - length
      ),
      0
    );

    this.visiblePages = Array.from(
      new Array(length).keys(),
      (item) => item + startIndex + 1
    );
  }

  private updateTotalPages(): void {
    this.totalPages = Math.ceil(this.total / this.value.pageSize);
  }
}
