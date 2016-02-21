import {Component, ViewEncapsulation, ViewChild} from 'angular2/core';
import {
  Router,
  RouteConfig,
  ROUTER_DIRECTIVES
} from 'angular2/router';

import {SignInCmp} from './pages/signin/signin';
import {MainCmp} from './pages/main/main';

@Component({
  selector: 'app',
  moduleId: module.id,
  templateUrl: './app.html',
  styleUrls: ['./app.css'],
  encapsulation: ViewEncapsulation.None,
  directives: [ROUTER_DIRECTIVES]
})
@RouteConfig([
  { path: '/', component: SignInCmp, name: 'SignIn' },
  { path: '/main', component: MainCmp, name: 'Main' }
])
export class AppCmp {
  router: Router;

  @ViewChild(SignInCmp) signInCmp: SignInCmp;

  constructor(router: Router) {
    this.router = router;

    let subs = null;

    router.subscribe(() => {
      if (subs) { subs.unsubscribe(); subs = null; }

      if (this.signInCmp) {
        subs = this.signInCmp.onSignIn.subscribe(data => this.onSignIn(data));
      }
    });
  }

  onSignIn(data) {
    console.log('onSignIn: ' + data);
    setTimeout(() => { this.router.navigate(['/Main']); });
  }
}
