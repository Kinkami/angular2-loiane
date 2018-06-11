import { Directive, Input,TemplateRef,ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[appNgElse]'
})
export class NgElseDirective {

  @Input() set ngElse(condition: boolean){

  }

  constructor() { }

}
