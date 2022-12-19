package hello.hellospring.repository;

import hello.hellospring.domain.Member;

import java.util.List;
import java.util.Optional;

public interface MemberRepository {

    Member save(Member member); // 저장소 저장
    Optional<Member> findById(Long id); // id 이용 찾기
    Optional<Member> findByName(String name); // 이름 이용 찾기
    List<Member> findAll(); //찾기

}
