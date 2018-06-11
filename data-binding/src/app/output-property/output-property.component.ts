import { Component, OnInit, Input, EventEmitter,Output,ViewChild } from '@angular/core';

@Component({
  selector: 'contador',
  templateUrl: './output-property.component.html',
  styleUrls: ['./output-property.component.css']
})
export class OutputPropertyComponent implements OnInit {

  @Input() valor: number = 0;

  @Output() mudouValor = new EventEmitter();

  @ViewChild('campoInput') campoValorInput: HTMLFontElement

  incrementa() {
    console.log(this.campoValorInput);
    this.valor++;
    this.mudouValor.emit({ novovalor: this.valor });
  }

  decrementa() {
    this.valor--;
    this.mudouValor.emit({ novovalor: this.valor });
  }

  constructor() { }

  ngOnInit() {
  }

}
