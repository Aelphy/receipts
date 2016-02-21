import {Component, Output, EventEmitter} from 'angular2/core';
import {FormBuilder, Validators, CORE_DIRECTIVES, FORM_DIRECTIVES, ControlGroup} from 'angular2/common';

@Component({
  selector: 'signin',
  moduleId: module.id,
  templateUrl: './signin.html',
  styleUrls: ['./signin.css'],
  directives: [FORM_DIRECTIVES, CORE_DIRECTIVES]
})
export class SignInCmp {
  form: ControlGroup;
  @Output() onSignIn = new EventEmitter();

  constructor(formBuilder: FormBuilder) {
    this.form = formBuilder.group({
      phone: ['', Validators.required],
      password: ['', Validators.required],
    });
  }

  ngAfterViewInit() {
    componentHandler.upgradeAllRegistered();
  }

  signIn() {
    console.log('SignIn');
    console.log(this.form);
    this.onSignIn.emit('event');
  }

  password() {
    console.log('password');
  }
}
