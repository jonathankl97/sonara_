import { Module } from '@nestjs/common';
import { FirebaseAuthGuard } from './firebase-auth.guard';
import * as admin from 'firebase-admin';
import * as fs from 'fs';

@Module({
  providers: [
    {
      provide: 'FIREBASE_APP',
      useFactory: () => {
        let serviceAccount: admin.ServiceAccount;

        if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
          serviceAccount = JSON.parse(
            process.env.FIREBASE_SERVICE_ACCOUNT_JSON,
          ) as admin.ServiceAccount;
        } else {
          const raw = fs.readFileSync(
            process.env.FIREBASE_SERVICE_ACCOUNT_PATH ??
              './firebase-service-account.json',
            'utf8',
          );
          serviceAccount = JSON.parse(raw) as admin.ServiceAccount;
        }

        return admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
      },
    },
    FirebaseAuthGuard,
  ],
  exports: [FirebaseAuthGuard],
})
export class FirebaseAuthModule {}
