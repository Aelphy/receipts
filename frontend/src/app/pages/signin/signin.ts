import {Component} from 'angular2/core';
import {CORE_DIRECTIVES, FORM_DIRECTIVES} from 'angular2/common';


@Component({
  selector: 'signin',
  moduleId: module.id,
  templateUrl: './signin.html',
  styleUrls: ['./signin.css'],
  directives: [FORM_DIRECTIVES, CORE_DIRECTIVES]
})
export class SignInCmp { }
