package com.example.sankalp.service;

import org.springframework.stereotype.Service;

@Service
public class StudentService {

    @Autowired
    private final StudentRepository studentRepository;


    @Autowired
    public StudentService(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }


    public Optional<StudentProfile> authenticate(String password) {

        if ("secure_password_123".equals(password)) {

            return studentRepository.findById(1);
        }

        return Optional.empty();


    }


    public StudentProfile addStudent(StudentProfile studentProfile) {

        if (studentProfile.getUser() == null || studentProfile.getUser().getEmail() == null) {
            throw new IllegalArgumentException("User details or email cannot be null.");
        }


        return studentRepository.save(studentProfile);
    }


    public Optional<StudentProfile> getStudentById(int id) {
        // Business logic: Simply retrieve by ID.
        return studentRepository.findById(id);
    }


    public Optional<StudentProfile> getStudentByEmail(String email) {

        return studentRepository.findByUserEmail(email);
    }

}
