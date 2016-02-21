import {Component, ViewEncapsulation} from 'angular2/core';
import {
  RouteConfig,
  ROUTER_DIRECTIVES
} from 'angular2/router';

import {SignInCmp} from './pages/signin/signin';

@Component({
  selector: 'app',
  moduleId: module.id,
  templateUrl: './app.html',
  styleUrls: ['./app.css'],
  encapsulation: ViewEncapsulation.None,
  directives: [ROUTER_DIRECTIVES]
})
@RouteConfig([
    { path: '/', component: SignInCmp, name: 'SignIn' }
])
export class AppCmp {}
