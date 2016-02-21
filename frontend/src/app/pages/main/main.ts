import {Component} from 'angular2/core';
import {CORE_DIRECTIVES, FORM_DIRECTIVES} from 'angular2/common';

@Component({
  selector: 'main',
  moduleId: module.id,
  templateUrl: './main.html',
  styleUrls: ['./main.css'],
  directives: [FORM_DIRECTIVES, CORE_DIRECTIVES]
})
export class MainCmp {
  ngAfterViewInit() {
    componentHandler.upgradeAllRegistered();
  }
}
