package hello.hellospring.service;

import hello.hellospring.domain.Member;
import hello.hellospring.repository.MemberRepository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

// 클래스 테스트 단축키 > Ctrl + Shift + T
//@Service
@Transactional
public class MemberService {

    //test시 똑같은 인스턴스 사용하기 위해 수정
    //public final MemberRepository memberRepository = new MemoryMemberRepository();
    private final MemberRepository memberRepository;

    //@Autowired
    public MemberService(MemberRepository memberRepository) {
        //memberRepository를 new해서 직접 생성하는게 아니라 다른 곳에서 가져오도록 수정
        this.memberRepository = memberRepository;
    }

    //회원 가입
    public long join(Member member) {

        //같은 이름이 있는 중복 회원 x
        //null 가능성이 있는 경우 > optional + ifPresent 사용

        // 1. Optional 바로 반환하는것이 좋지는 않다.
        //Optional<Member> result = memberRepository.findByName(member.getName());
        //result.ifPresent(m -> { });

        //2. 바로 ifPresent 사용
        //memberRepository.findByName(member.getName())
        //        .ifPresent(m -> {
        //            throw new IllegalStateException("이미 존재하는 회원입니다.");
        //        });

        //3. 메소드 추출 단축키 > Ctrl + Alt + M
        //중복 회원 검증
        //validateDuplicateMember(member);

        //memberRepository.save(member);
        //return member.getId();

        long start = System.currentTimeMillis();

        try {
            validateDuplicateMember(member); //중복 회원 검증
            memberRepository.save(member);
            return member.getId();
        } finally {
            long finish = System.currentTimeMillis();
            long timeMs = finish - start;
            System.out.println("join " + timeMs + "ms");
        }

    }

    private void validateDuplicateMember(Member member) {
        memberRepository.findByName(member.getName())
                .ifPresent(m -> {
                    throw new IllegalStateException("이미 존재하는 회원입니다.");
                });
    }

    //전체 회원 조회
    public List<Member> findMembers() {

        long start = System.currentTimeMillis();
        try {
            return memberRepository.findAll();
        } finally {
            long finish = System.currentTimeMillis();
            long timeMs = finish - start;
            System.out.println("findMembers " + timeMs + "ms");
        }

    }

    public Optional<Member> findOne(Long memberId) {
        return memberRepository.findById(memberId);
    }

}
