package jpabook.jpashop.repository;

import jpabook.jpashop.domain.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class MemberRepositoryOld {

    //@PersistenceContext > @Autowired : 스프링부트에서 지원해주기 때문에 변경 가능
    //@Autowired > final 키워드 추가 + @RequiredArgsConstructor
    private final EntityManager em;
    //스프링이 EntityManager를 만들어서 주입해 줌

    //@PersistenceUnit
    //private EntityManagerFactory emf;
    //EntityManagerFactory도 직접 주입 받을 수 있음

    //회원 등록
    public void save(Member member) {
        em.persist(member);
    }
    //EntityManager 사용
    //persist하면 영속석 context에 member entity를 넣는다
    //트랜잭션이 commit하는 시점에 DB에 반영된다(insert 쿼리)

    //단건 조회
    public Member findOne(Long id) {
        return em.find(Member.class, id);
        //em.find(타입, PK)
    }

    //전체 조회
    public List<Member> findAll() {
        //List<Member> result = em.createQuery("select m from Member m", Member.class).getResultList();
        //return result;
        return em.createQuery("select m from Member m", Member.class).getResultList();
        //JPQL 문법 사용, from의 대상은 테이블 아니고 entity
    }

    //이름으로 조회
    public List<Member> findByName(String name) {
        return em.createQuery("select m from Member m where m.name = :name", Member.class)
                .setParameter("name", name)
                .getResultList();
    }

}
