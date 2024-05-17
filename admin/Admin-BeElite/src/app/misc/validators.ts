import {
  AbstractControl,
  AsyncValidatorFn,
  FormGroup,
  ValidationErrors,
  ValidatorFn,
} from '@angular/forms';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { PostService } from '../service/post/post.service';

export function usernameValidator(postService: PostService): AsyncValidatorFn {
  return (control: AbstractControl): Observable<ValidationErrors | null> => {
    const username = control.value;

    // If control is empty, return null (no error)
    if (!username) {
      return of(null);
    }

    // Use postService to check the username asynchronously
    return postService.checkUsername(username).pipe(
      map(res => {
        // If username exists, return an error object
        if (!res) {
          return { usernameUnavailable: true };
        } else {
          // If username doesn't exist, return null (no error)
          return null;
        }
      })
    );
  };
}

export const matchpassword: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const password = control.get('password');
  const confirmpassword = control.get('verifyPassword');

  if (password && confirmpassword && password.value !== confirmpassword.value) {
    return {
      passwordMissmatch: true
    };
  }
  return null;
};