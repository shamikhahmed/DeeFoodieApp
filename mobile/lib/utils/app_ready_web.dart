import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// C-20: signal Playwright / Lighthouse that the first real frame is up.
void markAppReady() {
  globalContext.setProperty('__APP_READY__'.toJS, true.toJS);
}
