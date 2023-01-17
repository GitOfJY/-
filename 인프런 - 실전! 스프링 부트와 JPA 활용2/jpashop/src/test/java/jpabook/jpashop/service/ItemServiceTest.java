package jpabook.jpashop.service;

import jpabook.jpashop.domain.item.Book;
import jpabook.jpashop.repository.ItemRepository;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class ItemServiceTest {

    @Autowired ItemService itemService;
    @Autowired ItemRepository itemRepository;

    //@Test
    //@Rollback(false) > insert문 확인 방법1.
    //public void 회원가입() throws Exception {
    //given
    //Member member = new Member();
    //member.setName("kim");

    //when
    //Long saveId = memberService.join(member);

    //then
    //em.flush();
    //assertEquals(member, memberRepository.findOne(saveId));
    //}

    @Test
    public void 상품등록() throws Exception {

        Book book = new Book();
        book.setAuthor("kim");
        book.setIsbn("12345");

        itemService.saveItem(book);

        //itemService의 경우 DB에 넣지 않으면 id가 정해져있지 않다.
        //아이템을 저장하는 메서드에서 저장된 아이템 아이디를 반환하도록 해준다.
        //그걸 이용해서 findOne을 수행하면 아이템이 반환, 그 값이 null인지 아닌지 체크하는 방식으로 테스트 수행
        //필요하다면 기존 item과 반환된 item의 상태를 비교해주는 테스트 수행

    }


}