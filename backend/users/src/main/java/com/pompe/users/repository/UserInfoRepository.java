package com.pompe.users.repository;

import com.pompe.users.entity.UserInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserInfoRepository extends JpaRepository<UserInfo,Integer> {
    Optional<UserInfo> findByEmail(String name);
    boolean existsByName(String name);
    boolean existsByEmail(String email);

}
