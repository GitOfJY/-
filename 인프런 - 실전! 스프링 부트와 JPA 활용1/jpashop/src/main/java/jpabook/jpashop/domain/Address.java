package jpabook.jpashop.domain;

import lombok.Getter;

import javax.persistence.Embeddable;

@Embeddable
@Getter
public class Address {

    private String city;
    private String street;
    private String zipcode;

    //JPA 스펙상 추가한 코드
    protected Address() {
    }

    //값 > immutable하게 생성, 따라서 setter 아예 제공하지 않게 설계
    public Address(String city, String street, String zipcode) {
        this.city = city;
        this.street = street;
        this.zipcode = zipcode;
    }

}
