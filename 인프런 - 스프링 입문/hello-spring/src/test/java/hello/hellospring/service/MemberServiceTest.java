package hello.hellospring.service;

import hello.hellospring.domain.Member;
import hello.hellospring.repository.MemoryMemberRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;


import static org.junit.jupiter.api.Assertions.*;

class MemberServiceTest {

    //MemberService memberService = new MemberService();
    //MemoryMemberRepository memberRepository = new MemoryMemberRepository();
    //MemberService에서 실제 사용하는 memberRepository와 test에서 사용하는 MemberRepository가 다름 > 오류 발생할 수 있음

    //memberService 수정, MemberServiceTest 수정
    MemberService memberService;
    MemoryMemberRepository memberRepository;

    @BeforeEach
    public void beforeEach() {

        //test 시행할 때마다 memoryMemberRepository 생성하고 memberService에 전달
        //같은 memoryMemberRepository 사용 가능
        //DI
        memberRepository = new MemoryMemberRepository();
        memberService = new MemberService(memberRepository);
    }


    @AfterEach
    public void afterEach() {
        memberRepository.clearStore();
    }

    //test는 한국어 method 이름 가능
    //빌드될 때 실제 코드에 포함되지 않는다
    @Test
    void 회원가입() {

        //given, when, then 사용
        //given
        Member member = new Member();
        member.setName("spring");

        //when
        Long saveId = memberService.join(member);

        //then
        Member findMember = memberService.findOne(saveId).get();
        assertThat(member.getName()).isEqualTo(findMember.getName());

    }

    @Test
    public void 중복_회원_예외() {
        //test시 예외도 꼭 확인해야함

        //given
        Member member1 = new Member();
        member1.setName("spring");

        Member member2 = new Member();
        member2.setName("spring");

        //when 방법 1
        //memberService.join(member1);
        //try {
        //    memberService.join(member2);
        //    fail();
        //} catch (IllegalStateException e) {
            //예외가 정상적으로 실행
        //    assertThat(e.getMessage()).isEqualTo("이미 존재하는 회원입니다.");
        //}

        //when 방법 2
        memberService.join(member1);
        IllegalStateException e = assertThrows(IllegalStateException.class, () -> memberService.join(member2));
        assertThat(e.getMessage()).isEqualTo("이미 존재하는 회원입니다.");

    }


    @Test
    void findMembers() {
    }

    @Test
    void findOne() {
    }
}