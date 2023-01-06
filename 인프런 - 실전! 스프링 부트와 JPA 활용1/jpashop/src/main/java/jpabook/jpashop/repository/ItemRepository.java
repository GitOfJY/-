package jpabook.jpashop.repository;

import jpabook.jpashop.domain.item.Item;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ItemRepository {

    private final EntityManager em;

    public void save(Item item) {
        //item은 JPA 저장하기 전까지 id값이 없다
        //id값이 없다 > 완전히 새로 생성하는 객체
        if (item.getId() == null) {
            em.persist(item); //신규 등록
        } else {
            em.merge(item); //업데이트 의미
        }
    }

    public Item findOne(Long id) {
        return em.find(Item.class, id);
    }

    public List<Item> findAll() {
        return em.createQuery("select i from Item i", Item.class)
                .getResultList();
    }

}
