import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'image'
})
export class ImagePipe implements PipeTransform {

  transform(img: string): string {
    let url = 'assets/' ;
    return `url(${url}${img})`;
  }

}
