package jpabook.jpashop.service;

import jpabook.jpashop.domain.Member;
import jpabook.jpashop.repository.MemberRepository;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
//@Transactional
//JPA의 모든 데이터 변경이나 어떤 로직들은 트랜잭션 안에서 실행되어야 함
//스프링이 제공하는 트랜잭션 사용하는 것 권장 > 활용할 수 있는 옵션이 많음
@RequiredArgsConstructor
public class MemberService {

    //인젝션 방법1. 필드 인젝션
    //@Autowired
    //private MemberRepository memberRepository;
    //MemberRepository를 사용하기 위해 @Autowired로 injection
    //스프링이 스프링 빈에 등록되어있는 MemberRepository를 주입해준다.
    //보통 많이 사용하지만 단점이 많음, 필드+프라이빗 > 변경 불가능


    //인젝션 방법2. setter인젝션
    //private MemberRepository memberRepository;

    //@Autowired
    //public void setMemberRepository(MemberRepository memberRepository) {
    //    this.memberRepository = memberRepository;
    //}
    //장점 : testcode 작성 시 목과 같은 것들을 직접 주입해 줄 수 있음
    //단점 : (치명적) 실제 application 실행할 때 누군가가 setMemberRepository을 변결할 수 있다.


    //인젝션 방법3.1 생성자인젝션
    //private final MemberRepository memberRepository;
    //더 이상 변경할 일 없기 때문에 필드를 final로 변경

    //@Autowired
    //최신 스프링의 경우 생성자가 1개일 경우 자동으로 @Autowired, 따라서 생략 가능
    //public MemberService(MemberRepository memberRepository) {
    //    this.memberRepository = memberRepository;}
    //최근에 가장 많이 사용 됨
    //중간에 변경할 수 없고 testcase에 용이


    //인젝션 방법 3.2 생성자인젝션+@RequiredArgsConstructor
    private final MemberRepository memberRepository;
    //lombok > @RequiredArgsConstructor > final 있는 필드를 가지고 생성자 만들어 줌

    //회원 등록
    @Transactional //readOnly = false가 기본값
    public Long join(Member member) {
        //중복 회원 검증 비즈니스 로직 추가
        validateDuplicateMember(member);
        memberRepository.save(member);
        return member.getId();
    }

    private void validateDuplicateMember(Member member) {
        //Exception
        List<Member> findMembers = memberRepository.findByName(member.getName());
        if (!findMembers.isEmpty()) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        }
        //동시에 validateDuplicateMember 호출하면 문제 발생
        //비즈니스 로직이 있다고 해도 실무에서는 최후의 방어가 한 번 더 필요
        //멀티쓰레드 등과 같은 상황을 고려해 database에 유니크제약 조건 추가
    }

    //회원 전체 조회
    //@Transactional(readOnly = true) > JPA 조회하는 곳에서 성능을 최적화하게 도와줌
    public List<Member> findMembers() {
        return memberRepository.findAll();
    }

    //회원 단건 조회
    public Member findOne(Long memberId) {
        return memberRepository.findOne(memberId);
    }

}
