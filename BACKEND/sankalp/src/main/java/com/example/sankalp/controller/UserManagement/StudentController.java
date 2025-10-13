package com.example.sankalp.controller.UserManagement;

import com.example.sankalp.model.UserManagement.StudentProfile;
import com.example.sankalp.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    private final StudentService studentService;

    @Autowired
    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @PostMapping("/auth")
    public ResponseEntity<Map<String, String>> authenticate(@RequestBody Map<String, String> request) {
        String password = request.get("password");

        if (password == null) {
            return new ResponseEntity<>(
                    Collections.singletonMap("error", "Password is required"),
                    HttpStatus.BAD_REQUEST
            );
        }

        return studentService.authenticate(password)
                .map(profile -> {
                    String message = "Authentication successful for user_id: " + profile.getUser().getUser_id();
                    return new ResponseEntity<>(
                            Collections.singletonMap("message", message),
                            HttpStatus.OK
                    );
                })
                .orElseGet(() -> {
                    return new ResponseEntity<>(
                            Collections.singletonMap("error", "Authentication Failed. Invalid password."),
                            HttpStatus.UNAUTHORIZED
                    );
                });
    }

    @PostMapping
    public ResponseEntity<StudentProfile> addStudent(@RequestBody StudentProfile studentProfile) {
        try {
            StudentProfile newStudent = studentService.addStudent(studentProfile);
            return new ResponseEntity<>(newStudent, HttpStatus.CREATED);
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (IllegalStateException e) {
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentProfile> getStudentById(@PathVariable int id) {
        return studentService.getStudentById(id)
                .map(profile -> new ResponseEntity<>(profile, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<StudentProfile> getStudentByEmail(@PathVariable String email) {
        return studentService.getStudentByEmail(email)
                .map(profile -> new ResponseEntity<>(profile, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }
}