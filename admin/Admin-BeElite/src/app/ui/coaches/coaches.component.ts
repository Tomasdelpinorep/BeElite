import { Component } from '@angular/core';
import { UserDto } from '../../models/user-dto.intercace';
import { PostService } from '../../service/post/post.service';
import { environment } from '../../environment/environtments';
  
@Component({
    selector: 'app-coaches',
    standalone: false,
    templateUrl: './coaches.component.html',
    styleUrl: './coaches.component.css',
})
export class AdminCoachesComponent {
  
  coachList: UserDto[] = [];
  currentPage = 1;
  listSize! : number;
  defaultProfilePicUrl : String = environment.defaultProfilePicUrl;
      
  /*------------------------------------------
  --------------------------------------------
  Created constructor
  --------------------------------------------
  --------------------------------------------*/
  constructor(public postService: PostService) { }
      
  /**
   * Write code on Method
   *
   * @return response()
   */
  ngOnInit(): void {
    this.postService.getAllCoaches(this.currentPage - 1).subscribe(resp => {
      this.coachList = resp.content;
      this.listSize = resp.totalElements;
    }) 
  }

  deletePost(username:String){
    this.postService.delete(username).subscribe(res => {
         this.coachList = this.coachList.filter(item => item.username !== username);
         console.log('Post deleted successfully!');
    })
  }
  
}