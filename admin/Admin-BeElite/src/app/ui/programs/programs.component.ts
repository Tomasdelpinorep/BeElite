import { Component, HostBinding, TemplateRef } from '@angular/core';
import { UserDto } from '../../models/user-dto.intercace';
import { PostService } from '../../service/post/post.service';
import { environment } from '../../environment/environtments';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { ProgramDto } from '../../models/coach-details-dto.interface';

@Component({
  selector: 'app-programs',
  standalone: false,
  templateUrl: './programs.component.html',
  styleUrl: './programs.component.scss',
})
export class ProgramsComponent {
  @HostBinding('class.w-100') applyClass = true;
  closeResult = "";
  programList: ProgramDto[] = [];
  currentPage = 1;
  listSize!: number;
  defaultProgramPicUrl: string = environment.defaultProgramPicUrl;
  selectedProgramName!: string;
  selectedProgramCoachUsername!: string;
  apiBaseUrl: string = environment.apiBaseUrl;


  constructor(public postService: PostService, private modalService: NgbModal, private toastr: ToastrService) { }

  ngOnInit(): void {
    this.postService.getAllPrograms(this.currentPage - 1).subscribe(resp => {
      this.listSize = resp.totalElements;
      this.programList = resp.content;
      this.programList = this.programList.map(program => ({
        ...program,
        programPicUrl: `${this.apiBaseUrl}open/programPicture/${program.programName}`
      }))
    });
  }

  deleteProgram() {
    this.postService.deleteProgram(this.selectedProgramCoachUsername, this.selectedProgramName).subscribe(res => {
      this.toastr.success("Program successfully deleted", "Success!");

      this.modalService.dismissAll();
      setTimeout(() => {
        window.location.reload();
      }, 2000)
    });
  }



  openConfirmationDialog(content: TemplateRef<any>, programName: string, coachUsername: string) {
    this.selectedProgramName = programName;
    this.selectedProgramCoachUsername = coachUsername;

    this.modalService.open(content, { ariaLabelledBy: 'modal-basic-title' }).result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      },
    );
  }

  private getDismissReason(reason: any): string {
    switch (reason) {
      case ModalDismissReasons.ESC:
        return 'by pressing ESC';
      case ModalDismissReasons.BACKDROP_CLICK:
        return 'by clicking on a backdrop';
      default:
        return `with: ${reason}`;
    }
  }

  loadNewPage() {
    this.postService.getAllPrograms(this.currentPage - 1).subscribe(resp => {
      this.programList = resp.content;
    })

    if (this.programList.length == 1)
      window.location.reload();
  }

}