package com.crappycomic.emulator101

import java.util.concurrent.ArrayBlockingQueue

/**
 * Encapsulates an interrupt [Opcode] on the system bus.
 *
 * The 8080 CPU supports up to two bytes of data, but Invaders doesn't use it, so we'll skip it.
 * If we support data bytes later, this queue should change to hold a class that encapsulates the
 * opcode plus the optional data.
 */
val interrupts = ArrayBlockingQueue<Opcode>(1)
