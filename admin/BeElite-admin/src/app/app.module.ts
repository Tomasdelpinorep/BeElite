import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HTTP_INTERCEPTORS, provideHttpClient, withFetch } from '@angular/common/http';
import { RemoveWrapperInterceptor } from './misc/remove.wrapper.interceptor';
import { LoggerInterceptor } from './misc/logger.interceptor';


@NgModule({
  declarations: [
  ],
  imports: [
    CommonModule,
    FormsModule,
  ],
  providers: [{ provide: HTTP_INTERCEPTORS, useClass: LoggerInterceptor, multi: true }, provideHttpClient(withFetch()), {
    provide: HTTP_INTERCEPTORS,
    useClass: RemoveWrapperInterceptor,
    multi: true
  }],
})
export class PostModule { }
