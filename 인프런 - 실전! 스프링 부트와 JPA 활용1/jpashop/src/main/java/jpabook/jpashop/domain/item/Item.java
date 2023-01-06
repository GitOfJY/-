package jpabook.jpashop.domain.item;

import jpabook.jpashop.exception.NotEnoughStockException;
import lombok.Getter;
import lombok.Setter;
import jpabook.jpashop.domain.Category;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="dtype")
@Getter @Setter
public abstract class Item {

    //상속관계 맵핑 > 상속관계 전략 지정 > 싱글 테이블 전략
    //상송관계 전략은 부모 클래스에 잡아준다
    //@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
    //@DiscriminatorColumn(name="dtype"), @DiscriminatorValue("M") 추가
    
    @Id @GeneratedValue
    @Column(name="item_id")
    private Long id;
    
    //공통속성
    private String name;
    private int price;
    private int stockQuantity;

    @ManyToMany(mappedBy = "items")
    private List<Category> categories = new ArrayList<>();

    //비즈니스 로직
    //재고수 증가
    //도메인 주도 설계 > 엔티티 안에 비즈니스 로직 추가 (객체지향적)
    public void addStock(int quantity) {
        this.stockQuantity += quantity;
    }

    //재고 감소
    public void removeStock(int quantity) {
        int realStock = this.stockQuantity - quantity;
        if (realStock < 0) {
            throw new NotEnoughStockException("need more stock");
        }
        this.stockQuantity = realStock;
    }

    //@Setter 사용 대신 핵심비즈니스메서드(addStock, removeStock)를 이용해서 변경해야한다.
    //가장 객체지향적인 것

}
