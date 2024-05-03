import {
    AbstractControl,
    ValidationErrors,
} from '@angular/forms';
import { Observable, of, timer } from 'rxjs';
import { map, switchMap } from 'rxjs/operators';
import { PostService } from '../post/service/post/post.service';

  export function usernameValidator(postService: PostService, control: AbstractControl): Observable<ValidationErrors | null> {
    return timer(200).pipe(
      switchMap(() => {
        const value = control.value;
        if (!value) {
          return of(null);
        }
        return postService.checkUsername(value).pipe(
          map(isValid => {
            return isValid ? null : { isNotValid: true };
          })
        );
      })
    );
  }