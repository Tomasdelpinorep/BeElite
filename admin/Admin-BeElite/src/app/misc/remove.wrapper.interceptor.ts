import { Injectable } from '@angular/core';
import {
    HttpInterceptor,
    HttpRequest,
    HttpHandler,
    HttpEvent,
} from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable()
export class RemoveWrapperInterceptor implements HttpInterceptor {
    intercept(
        request: HttpRequest<any>,
        next: HttpHandler
    ): Observable<HttpEvent<any>> {
        // Check if the request has a body and if it has an "issue" property
        if (request.body && request.body.issue) {
            // Replace the request body with the "issue" property
            request = request.clone({
                body: request.body.issue,
            });
        }

        return next.handle(request);
    }
}